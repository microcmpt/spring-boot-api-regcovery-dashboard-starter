package com.msa.regcovery.dashboard;


import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.msa.regcovery.dashboard.support.Constant;
import lombok.*;
import org.I0Itec.zkclient.ZkClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

/**
 * The type Service operation endpoint.
 */
@Controller
public class RegCoveryDashboardController {

    /**
     * The Zk servers.
     */
    @Value("${spring.rpc.server.registry-address:localhost:2181}")
    private String zkServers;

    /**
     * Sets zk servers.
     *
     * @param zkServers the zk servers
     */
    public void setZkServers(String zkServers) {
        this.zkServers = zkServers;
    }

    /**
     * Gets services.
     *
     * @return the services
     */
    @RequestMapping("/regcovery-ui.html")
    public String getServices(Model model) {
        Map<String, Object> map = Maps.newHashMap();
        map.put("result", "no");
        map.put("message", "服务不存在！");
        ZkClient zkClient = new ZkClient(zkServers, Constant.ZK_SESSION_TIMEOUT, Constant.ZK_CONNECTION_TIMEOUT);
        try {
            if (zkClient.exists(Constant.ZK_REGISTRY)) {
                List<ServiceNode> serviceNodes = Lists.newArrayList();
                List<String> serviceNameNodes = zkClient.getChildren(Constant.ZK_REGISTRY);
                if (CollectionUtils.isEmpty(serviceNameNodes)) {
                    model.addAttribute("map", map);
                }
                serviceNameNodes.parallelStream().forEach(serviceNameNode -> {
                    List<String> serviceAddrNodes = zkClient.getChildren(Constant.ZK_REGISTRY + "/" + serviceNameNode);
                    if (CollectionUtils.isEmpty(serviceAddrNodes)) {
                        return;
                    }
                    serviceAddrNodes.parallelStream().map(serviceAddrNode -> {
                        String serviceAddr = zkClient.readData(Constant.ZK_REGISTRY + "/" + serviceNameNode + "/" + serviceAddrNode);
                        ServiceNode serviceNode = ServiceNode.builder()
                                .rootNode(Constant.ZK_REGISTRY)
                                .childNode(serviceNameNode)
                                .subChildNode(serviceAddrNode)
                                .serviceAddr(serviceAddr)
                                .build();
                        return serviceNode;
                    }).forEach(serviceNodes::add);
                });
                map.put("result", "ok");
                map.put("data", serviceNodes);
                map.remove("message");
            } else {
                model.addAttribute("map", map);
            }
        } finally {
            zkClient.close();
        }
        model.addAttribute("map", map);
        return "/index";
    }

    /**
     * The type Service node.
     */
    @Setter
    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static final class ServiceNode {
        /**
         * The Root node.
         */
        private String rootNode;

        /**
         * The Child node.
         */
        private String childNode;

        /**
         * The Sub child node.
         */
        private String subChildNode;

        /**
         * The Service addr.
         */
        private String serviceAddr;
    }
}

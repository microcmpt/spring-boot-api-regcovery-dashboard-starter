package com.msa.regcovery.dashboard;


import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.msa.regcovery.dashboard.support.Constant;
import com.msa.regcovery.dashboard.support.RegcoveryDashboardProperties;
import lombok.*;
import org.I0Itec.zkclient.ZkClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

/**
 * The type Service operation endpoint.
 */
@Controller
public class RegCoveryDashboardController {

    /**
     * The Properties.
     */
    @Autowired
    private RegcoveryDashboardProperties properties;

    /**
     * Gets services.
     *
     * @param model the model
     * @return the services
     */
    @RequestMapping("/regcovery-ui.html")
    public String getServices(Model model) {
        Map<String, Object> map = Maps.newHashMap();
        map.put("result", "fail");
        map.put("message", "服务不存在！");
        ZkClient zkClient = new ZkClient(properties.getZkServers(), Constant.ZK_SESSION_TIMEOUT, Constant.ZK_CONNECTION_TIMEOUT);
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
                    final StringBuilder stringBuilder = new StringBuilder();
                    boolean appFlag[] = {false};
                    serviceAddrNodes.parallelStream().forEach(serviceAddrNode -> {
                        String serviceAddr = zkClient.readData(Constant.ZK_REGISTRY + "/" + serviceNameNode + "/" + serviceAddrNode);
                        if (StringUtils.hasText(serviceAddr)) {
                            appFlag[0] = serviceAddr.startsWith(":=");
                            serviceAddr = appFlag[0] ? serviceAddr.substring(":=".length()) : serviceAddr;
                            stringBuilder.append(serviceAddr).append(",");
                        }
                    });
                    ServiceNode.ServiceNodeBuilder serviceNodeBuilder = ServiceNode.builder()
                            .childNode(serviceNameNode)
                            .isApp(appFlag[0]+"");
                    if (StringUtils.hasText(stringBuilder)) {
                        serviceNodeBuilder.serviceAddrs(stringBuilder.substring(0, stringBuilder.length() - 1));
                    }
                    serviceNodes.add(serviceNodeBuilder.build());
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
         * The Child node.
         */
        private String childNode;

        /**
         * The Service addrs.
         */
        private String serviceAddrs;

        /**
         * The Is app.
         */
        private String isApp;
    }
}

package com.msa.regcovery.dashboard.support;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * The type Regcovery dashboard properties.
 */
@Data
@Configuration
public class RegcoveryDashboardProperties {

    /**
     * The Zk servers.
     */
    @Value("${spring.regcovery.registry-address:localhost:2181}")
    private String zkServers;
}

package com.msa.regcovery.dashboard.support.freemarker;

import com.msa.regcovery.dashboard.RegCoveryDashboardController;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

/**
 * The type Reg covery dashboard configuration.
 *
 * @author sxp
 */
@Configuration
public class RegCoveryDashboardConfiguration {

    /**
     * The constant DEFAULT_TEMPLATE_LOADER_PATH.
     */
    private static final String DEFAULT_TEMPLATE_LOADER_PATH = "classpath:/templates/";

    /**
     * The constant DEFAULT_CHARSET.
     */
    private static final String DEFAULT_CHARSET = "UTF-8";

    /**
     * Free marker configurer free marker configurer.
     *
     * @return the free marker configurer
     */
    @Bean
    public FreeMarkerConfigurer freeMarkerConfigurer() {
        FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
        configurer.setTemplateLoaderPaths(DEFAULT_TEMPLATE_LOADER_PATH);
        configurer.setDefaultEncoding(DEFAULT_CHARSET);
        configurer.setPreferFileSystemAccess(false);
        return configurer;
    }

    /**
     * Reg covery dashboard controller reg covery dashboard controller.
     *
     * @return the reg covery dashboard controller
     */
    @Bean
    public RegCoveryDashboardController regCoveryDashboardController() {
        return new RegCoveryDashboardController();
    }
}

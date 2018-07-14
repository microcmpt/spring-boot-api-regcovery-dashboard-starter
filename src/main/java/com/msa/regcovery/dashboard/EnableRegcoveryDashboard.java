package com.msa.regcovery.dashboard;

import com.msa.regcovery.dashboard.support.RegCoveryDashboardConfiguration;
import org.springframework.context.annotation.Import;

import java.lang.annotation.*;

/**
 * The interface Enable regcovery dashboard.
 * @author sxp
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
@Import({RegCoveryDashboardConfiguration.class})
public @interface EnableRegcoveryDashboard {
}

# spring-boot-api-regcovery-dashboard-starter
[![Build Status](https://travis-ci.org/microcmpt/spring-boot-api-regcovery-dashboard-starter.svg?branch=master)](https://travis-ci.org/microcmpt/spring-boot-api-regcovery-dashboard-starter) [![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
### Introduction
用于和spring boot结合自动配置，开启服务注册中心web控制台，可以查看服务注册中心服务信息详细或者删除新增修改服务操作。

### Quick Start
step1:引入spring-boot-api-regcovery-dashboard包<br/>
maven:
```
<dependency>
  <groupId>com.github.microcmpt</groupId>
  <artifactId>spring-boot-api-regcovery-dashboard-starter</artifactId>
  <version>1.0.0</version>
</dependency>
```
gradle:
```
compile 'com.github.microcmpt:spring-boot-api-regcovery-dashboard-starter:1.0.0'
```
step2:开启注册中心web控制台，在启动类上加@EnableRegcoveryDashboard
```$xslt
@SpringBootApplication
@EnableRpc4jServer
@EnableRegcoveryDashboard
public class Rpc4jServerSampleApplication {
	public static void main(String[] args) {
		SpringApplication.run(Rpc4jServerSampleApplication.class, args);
	}
}
```
step3:访问http://localhost:8080/regcovery-ui.html
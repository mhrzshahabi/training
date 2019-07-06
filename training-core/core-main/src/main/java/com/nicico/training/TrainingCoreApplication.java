package com.nicico.training;

import net.sf.jasperreports.engine.JRException;
import org.activiti.spring.boot.SecurityAutoConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = {"com.nicico"}, exclude = {SecurityAutoConfiguration.class})
@EnableJpaAuditing(modifyOnCreate = false, auditorAwareRef = "auditorProvider")
@EntityScan(basePackages = {"com.nicico"})
@EnableJpaRepositories("com.nicico")
public class TrainingCoreApplication {

	public static void main(String[] args) throws JRException {
		SpringApplication.run(TrainingCoreApplication.class, args);
	}
}

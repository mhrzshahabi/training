package com.nicico.training;

import org.activiti.spring.boot.SecurityAutoConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = {"com.nicico"}, exclude = {SecurityAutoConfiguration.class})
@EnableJpaAuditing(modifyOnCreate = false, auditorAwareRef = "auditorProvider")
@EnableJpaRepositories("com.nicico")
public class TrainingApplication {

	public static void main(String[] args) {
		SpringApplication.run(TrainingApplication.class, args);
	}
}















package com.nicico.training;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = {"com.nicico"})
public class TrainingWebApplication {

	public static void main(String[] args) {
		SpringApplication.run(TrainingWebApplication.class, args);
	}
}

package com.nicico.training.config;

import com.nicico.training.component.TrainingInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Component
public class TrainingInterceptorConfig extends WebMvcConfigurerAdapter {

    private TrainingInterceptor interceptor;

    public TrainingInterceptorConfig(TrainingInterceptor interceptor) {
        this.interceptor = interceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(interceptor);
    }
}

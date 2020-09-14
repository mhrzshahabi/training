package com.nicico.training.component;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.UUID;

@Slf4j
@Component
public class TrainingInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        long requestTime = System.currentTimeMillis();
        String uuid = UUID.randomUUID().toString();

        request.setAttribute("requestTime", requestTime);
        request.setAttribute("requestId", uuid);

        if (request.getRequestURL().toString().contains("api")) {
            log.info("TRACE INCOMING REQUEST ID : {} --- URL : {} --- STRING QUERY : {}",
                    uuid,
                    request.getRequestURL(),
                    request.getQueryString()
            );
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        long requestTime = (long) request.getAttribute("requestTime");
        long executionTime = System.currentTimeMillis() - requestTime;
        if (request.getRequestURL().toString().contains("api")) {
            log.info("TRACE RESPONSE REQUEST ID : {} --- URL : {} --- STRING QUERY : {} PROCESS TIME : {} MILLISECONDS",
                    request.getAttribute("requestId"),
                    request.getRequestURL(),
                    request.getQueryString(),
                    executionTime);
        }
    }

}

package com.nicico.training.client.oauth;

import com.nicico.copper.oauth.common.dto.OAUserDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(value = "oauthClient", url ="${nicico.oauthUrl}")
public interface OauthClient {

    @GetMapping("/api/users/{id}")
    ResponseEntity<OAUserDTO.InfoByApp> get(@PathVariable Long id);

}

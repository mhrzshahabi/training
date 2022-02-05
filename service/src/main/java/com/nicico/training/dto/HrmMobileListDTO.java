package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Map;

public class HrmMobileListDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    public static class Response {
        private Map<String, String> result;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    public static class Request {
        private List<String> nationalCodes;
    }
}

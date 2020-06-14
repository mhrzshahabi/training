package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class CategoriesPerformanceViewDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CategoriesInfo")
    public static class Info extends CategoriesPerformanceViewDTO{
        private Long id;
    }
}

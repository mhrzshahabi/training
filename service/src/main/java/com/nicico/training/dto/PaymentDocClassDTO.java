package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class PaymentDocClassDTO implements Serializable {

    private String titleClass
            ;
    private String code;

    private String classDuration;

    private String timeSpent;

    private Long teachingCostPerHour;

    private String finalAmount;

    private Long paymentDocId;




    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PaymentDocClassDTO - Info")
    public static class Info extends PaymentDocClassDTO {
        private Long id;

    }
//
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PaymentDocClassDTO - Create")
    public static class Create extends PaymentDocClassDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PaymentDocClassDTO - Update")
    public static class Update extends PaymentDocClassDTO {
        private Long id;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("PaymentDocClassDTOSpecRs")
    public static class CourseSpecRs {
        private PaymentDocClassDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

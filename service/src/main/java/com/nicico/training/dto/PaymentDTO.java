package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class PaymentDTO implements Serializable {

    private Long agreementId;
    private AgreementDTO agreement;
    private String paymentDocStatus;
    private Date lastModifiedDate;;
    private Date createdDate;;
    private String createdBy;;
    private String lastModifiedBy;;
    private Set<String> classCodes;



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Agreement - Info")
    public static class Info extends PaymentDTO {
        private Long id;

    }
//
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Payment - Create")
    public static class Create extends PaymentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Payment - Update")
    public static class Update extends PaymentDTO {
        private Long id;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("PaymentSpecRs")
    public static class CourseSpecRs {
        private PaymentDTO.SpecRs response;
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

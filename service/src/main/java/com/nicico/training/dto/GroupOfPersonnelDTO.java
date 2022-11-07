package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class GroupOfPersonnelDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String code;
    @ApiModelProperty()
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GroupOfPersonnelInfo")
    public static class Info extends GroupOfPersonnelDTO {
        private Long id;
        private Set<PersonnelDTO.Info> personnelSet;
    }

//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("JobGroupTuple")
//    public static class Tuple extends GroupOfPersonnelDTO {
//    }
//
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GroupOfPersonnelCreateRq")
    public static class Create extends GroupOfPersonnelDTO {
//        private Set<Long> personnelIds;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GroupOfPersonnelUpdateRq")
    public static class Update extends GroupOfPersonnelDTO {
        private Long id;
    }
//
//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("JobGroupIdListRq")
//    public static class JobGroupIdList {
//        @NotNull
//        @ApiModelProperty(required = true)
//        private List<Long> ids;
//    }
//
//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("JobGroupDeleteRq")
//    public static class Delete {
//        @NotNull
//        @ApiModelProperty(required = true)
//        private Set<Long> ids;
//    }
//
//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @JsonInclude(JsonInclude.Include.NON_NULL)
//    @ApiModel("JobGroupSpecRs")
//    public static class JobGroupSpecRs {
//        private SpecRs response;
//    }
//
//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @JsonInclude(JsonInclude.Include.NON_NULL)
//    public static class SpecRs {
//        private List<Info> data;
//        private Integer status;
//        private Integer startRow;
//        private Integer endRow;
//        private Integer totalRows;
//    }
}

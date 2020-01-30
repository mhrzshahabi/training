package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.model.EmploymentHistory;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@Accessors(chain = true)
public class EmploymentHistoryDTO {

    private String companyName;
    private String jobTitle;
    private Date startDate;
    private Date endDate;
    private Long teacherId;

    public String getPersianStartDate() {
        if (startDate == null)
            return null;
        SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
        return DateUtil.convertMiToKh(ft.format(startDate));
    }

    public void setPersianStartDate(String persianStartDate) {
        try {
            this.startDate = new SimpleDateFormat("yyyy-MM-dd").parse(DateUtil.convertKhToMi1(persianStartDate));
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    public String getPersianEndDate() {
        if (endDate == null)
            return null;
        SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
        return DateUtil.convertMiToKh(ft.format(endDate));
    }

    public void setPersianEndDate(String persianEndDate) {
        try {
            this.endDate = new SimpleDateFormat("yyyy-MM-dd").parse(DateUtil.convertKhToMi1(persianEndDate));
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Info")
    public static class Info extends EmploymentHistoryDTO {
        private Long id;
        private Integer version;
        private List<CategoryDTO.CategoryInfoTuple> categories;
        private List<SubCategoryDTO.SubCategoryInfoTuple> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Grid")
    public static class Grid{
        private Long id;
        private Integer version;
        private List<CategoryDTO.Info> categories;
        private List<SubCategoryDTO.Info> subCategories;

        public List<Long> getCategories() {
            if (categories == null)
                return null;
            return categories.stream().map(CategoryDTO.Info::getId).collect(Collectors.toList());
        }

        public List<Long> getSubCategories() {
            if (subCategories == null)
                return null;
            return subCategories.stream().map(SubCategoryDTO.Info::getId).collect(Collectors.toList());
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Create")
    public static class Create extends EmploymentHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubCategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Update")
    public static class Update extends EmploymentHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubCategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EmploymentHistory - RsGrid")
    public static class EmploymentHistorySpecRsGrid {
        private EmploymentHistoryDTO.SpecRsGrid response;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsGrid {
        private List<EmploymentHistoryDTO.Grid> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

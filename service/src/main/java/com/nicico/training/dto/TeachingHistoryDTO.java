package com.nicico.training.dto;

import com.nicico.copper.common.util.date.DateUtil;
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
public class TeachingHistoryDTO {

    private String courseTitle;
    private Long educationLevelId;
    private Integer duration;
    private Date startDate;
    private Date endDate;
    private Long teacherId;
    private String companyName;


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
    @ApiModel("TeachingHistory - Info")
    public static class Info extends TeachingHistoryDTO {
        private Long id;
        private Integer version;
        private List<CategoryDTO.CategoryInfoTuple> categories;
        private List<SubCategoryDTO.SubCategoryInfoTuple> subCategories;
        private EducationLevelDTO.Info educationLevel;
        public List<Long> getCategoriesIds() {
            if (categories == null)
                return null;
            return categories.stream().map(CategoryDTO.CategoryInfoTuple::getId).collect(Collectors.toList());
        }

        public List<Long> getSubCategoriesIds() {
            if (subCategories == null)
                return null;
            return subCategories.stream().map(SubCategoryDTO.SubCategoryInfoTuple::getId).collect(Collectors.toList());
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeachingHistory - Create")
    public static class Create extends TeachingHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubCategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeachingHistory - Update")
    public static class Update extends TeachingHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubCategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeachingHistory - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}

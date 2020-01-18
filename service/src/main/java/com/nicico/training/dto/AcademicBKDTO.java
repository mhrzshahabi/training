package com.nicico.training.dto;

import com.nicico.copper.common.util.date.DateUtil;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class AcademicBKDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationMajorId;
    private Long educationOrientationId;
    private Date date;
    private String duration;
    private String academicGrade;
    private String collageName;
    private Long teacherId;

    public String getPersianDate() {
        if (date == null)
            return null;
        SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
        return DateUtil.convertMiToKh(ft.format(date));
    }

    public void setPersianDate(String persianStartDate) {
        try {
            this.date = new SimpleDateFormat("yyyy-MM-dd").parse(DateUtil.convertKhToMi1(persianStartDate));
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Info")
    public static class Info extends AcademicBKDTO {
        private Long id;
        private Integer version;
        private EducationLevelDTO.Info educationLevel;
        private EducationMajorDTO.Info educationMajor;
        private EducationOrientationDTO.Info educationOrientation;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Create")
    public static class Create extends AcademicBKDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Update")
    public static class Update extends AcademicBKDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}

package com.nicico.training.dto;

import com.nicico.copper.common.util.date.DateUtil;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

@Getter
@Setter
@Accessors(chain = true)
public class PostDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Post - Info")
    public static class Info {
        private Long id;
        private String code;
        private String titleFa;
        private JobDTO.Info job;
        private PostGradeDTO.Info postGrade;
        private String area;
        private String mojtameTitle;
        private String assistance;
        private String affairs;
        private String section;
        private String unit;
        private String costCenterCode;
        private String costCenterTitleFa;
        private String peopleType;
        private Long enabled;
        private Long parentID;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Post - TupleInfo")
    public static class TupleInfo {
        private Long id;
        private String code;
        private String titleFa;
        private Long enabled;
        private Long deleted;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelInfo")
    public static class PersonnelInfo {
        private Long id;
        private String code;
        private String titleFa;
        private String peopleType;
        private Long enabled;
        private Long deleted;
        private JobDTO.Info job;
        private PostGradeDTO.Info postGrade;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelInfo")
    public static class needAssessmentInfo {
        private Date lastModifiedDateNA;
        private String modifiedByNA;

        public String getLastModifiedDateNA() {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            if (lastModifiedDateNA != null)
                return DateUtil.convertMiToKh(formatter.format(lastModifiedDateNA));
            return "آپ دیت نشده";
        }
    }
}

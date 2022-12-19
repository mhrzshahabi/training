package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Accessors(chain = true)
public class StudentDTO {
    @ApiModelProperty(required = true)
    private String firstName;
    @ApiModelProperty(required = true)
    private String lastName;
    @ApiModelProperty(required = true)
    private String nationalCode;
    @ApiModelProperty(required = true)
    private String companyName;
    @ApiModelProperty(required = true)
    private String personnelNo;
    private String personnelNo2;
    private String fatherName;
    private String birthCertificateNo;
    private String birthDate;
    private Integer age;
    private String birthPlace;
    private String employmentDate;
    private String postTitle;
    private String postCode;
    private String postAssignmentDate;
    private String complexTitle;
    private String operationalUnitTitle;
    private String employmentTypeTitle;
    private String maritalStatusTitle;
    private String workPlaceTitle;
    private String workTurnTitle;
    private String educationLevelTitle;
    private String jobNo;
    private String jobTitle;
    private Integer employmentStatusId;
    private String employmentStatus;
    private String contractNo;
    private String educationMajorTitle;
    private String gender;
    private String militaryStatus;
    private String educationLicenseType;
    private String departmentTitle;
    private String departmentCode;
    private String contractDescription;
    private String workYears;
    private String workMonths;
    private String workDays;
    private String insuranceCode;
    private String postGradeTitle;
    private String postGradeCode;
    private String ccpCode;
    private String ccpArea;
    private String ccpAssistant;
    private String ccpAffairs;
    private String ccpSection;
    private String ccpUnit;
    private String ccpTitle;
    private String scoresState;
    private String failureReason;
    private Float score;

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - Info")
    public static class Info extends StudentDTO {
        private Long id;

        public String getFullName() {
            return (getFirstName() + " " + getLastName()).compareTo("null null") == 0 ? null : getFirstName() + " " + getLastName();
        }
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - LMS - Info")
    public static class LmsInfo {
        @ApiModelProperty(required = true)
        private String firstName;
        @ApiModelProperty(required = true)
        private String lastName;
        @ApiModelProperty(required = true)
        private String nationalCode;
        @ApiModelProperty(required = true)
        private String personnelNo;
        private String birthCertificateNo;
        private String companyName;
        private String personnelNo2;
        private ContactInfoDTO.Info contactInfo;
        private String peopleType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Create")
    public static class Create extends StudentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Update")
    public static class Update extends StudentDTO {
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - UpdateForSyncData")
    public static class UpdateForSyncData extends StudentDTO {
        private Long postId;
        private Long departmentId;
        private boolean hasPreparationTest;
        private Long contactInfoId;
        private String userName;
        private Long geoWorkId;
        private String peopleType;





    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Ids")
    public static class Ids {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("Student - SpecRs")
    public static class StudentSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<StudentDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - ClassStudentInfo")
    public static class ClassStudentInfo {
        private Long id;
        @ApiModelProperty(required = true)
        private String firstName;
        @ApiModelProperty(required = true)
        private String lastName;
        @ApiModelProperty(required = true)
        private String nationalCode;
        @ApiModelProperty(required = true)
        private String personnelNo;
        private String personnelNo2;
        private String postTitle;
        private String ccpArea;
        private String ccpAssistant;
        private String ccpAffairs;
        private String ccpSection;
        private String ccpUnit;
        private String fatherName;
        private String birthCertificateNo;
        private String postCode;
        private String gender;
        private ContactInfoDTO.Info contactInfo;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - Attendance")
    public static class AttendanceInfo {
        private Long id;
        @ApiModelProperty(required = true)
        private String firstName;
        @ApiModelProperty(required = true)
        private String lastName;
        @ApiModelProperty(required = true)
        private String nationalCode;
        @ApiModelProperty(required = true)
        private String personnelNo;
        private String personnelNo2;
        @ApiModelProperty(required = true)
        private String companyName;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - Scores")
    public static class ScoresInfo {
        private Long id;
        @ApiModelProperty(required = true)
        private String firstName;
        @ApiModelProperty(required = true)
        private String lastName;
        @ApiModelProperty(required = true)
        private String nationalCode;
        @ApiModelProperty(required = true)
        private String personnelNo;
        private String postTitle;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - ClassesOfStudentInfo")
    public static class ClassesOfStudentInfo {
        private String postTitle;
        private String ccpAffairs;
        private String postCode;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Clear - Attendance")
    public static class clearAttendance {
        private String firstName;
        private String lastName;
        private String personnelNo;
        private String jobTitle;
        private String educationMajorTitle;
        private String ccpAffairs;
        private String nationalCode;
        @Getter(AccessLevel.NONE)
        private String fullName;

        public String getFullName() {
            return (firstName + " " + lastName).compareTo("null null") == 0 ? null : firstName + " " + lastName;
        }
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Clear With Attendance")
    public static class clearAttendanceWithState<T> extends clearAttendance {
        private Map<T, String> states;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Score - Attendance")
    public static class scoreAttendance {
        private String firstName;
        private String lastName;
        private String personnelNo;
        private String scoreA;
        private String scoreB;
        private String fullName;

        public String calScoreB(String score) {
            if (score == null || score.length() == 0)
                return "";

            String[] sections = score.split("\\.");
            String scoreStr = "";

            String[] singleMap = {"صفر", "يک", "دو", "سه", "چهار", "پنج", "شش", "هفت", "هشت", "نه", "ده", "يازده", "دوازده", "سيزده", "چهارده", "پانزده", "شانزده", "هفده", "هجده", "نوزده", "بيست"};

            if (sections[0] != null) {
                scoreStr = singleMap[Integer.parseInt(sections[0])];
            }
            if (sections[1] != null && !sections[1].equals("0")) {
                scoreStr += " و ";

                scoreStr += singleMap[sections[1].charAt(0) - '0'] + " ";

                if (sections[1].length() > 1)
                    scoreStr += singleMap[sections[1].charAt(1) - '0'];
            }
            return scoreStr;
        }
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Control - Attendance")
    public static class controlAttendance {
        private String firstName;
        private String lastName;
        private String personnelNo;
        private String personnelNo2;
        private String ccpAffairs;
        private String fullName;
        private String nationalCode;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Full - Attendance")
    public static class fullAttendance extends scoreAttendance {
        private String personnelNo2;
        private String ccpAffairs;
        private String educationMajorTitle;
        private String jobTitle;
        private Map<Integer, String> states;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("PreparationInfo")
    public static class PreparationInfo {
        private String nationalCode;
        private boolean hasPreparationTest;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("TrainingCertificationDetail")
    public static class TrainingCertificationDetail {
        private String peopleType;
        private String companyName;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - ReactionNotFilled")
    public static class ReactionNotFilled {
        private Long id;
        private String firstName;
        private String lastName;
        private String fullName;

        public String getFullName() {
            return (getFirstName() + " " + getLastName()).compareTo("null null") == 0 ? null : getFirstName() + " " + getLastName();
        }
    }
}

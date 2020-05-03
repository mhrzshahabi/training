/*
ghazanfari_f,
1/14/2020,
1:48 PM
*/
package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class NeedsAssessmentDTO implements Serializable {

    @NotNull
    @ApiModelProperty(required = true)
    private Long objectId;

    @NotNull
    @ApiModelProperty(required = true)
    private String objectType;

    @NotNull
    @ApiModelProperty(required = true)
    private Long competenceId;

    @NotNull
    @ApiModelProperty(required = true)
    private Long skillId;

    @NotNull
    @ApiModelProperty(required = true)
    private Long needsAssessmentDomainId;

    @NotNull
    @ApiModelProperty(required = true)
    private Long needsAssessmentPriorityId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Info")
    public static class Info extends NeedsAssessmentDTO {
        private Long id;
        private Integer version;
        private String objectName;
        private String objectCode;
        private CompetenceDTO.Info competence;
        private SkillDTO.Info skill;
        private ParameterValueDTO.MinInfo needsAssessmentDomain;
        private ParameterValueDTO.MinInfo needsAssessmentPriority;
        private String workflowStatus;
        private Integer workflowStatusCode;
        private String mainWorkflowStatus;
        private Integer mainWorkflowStatusCode;
//        private E object;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Tree")
    public static class Tree extends Info {
        private Long parentId;
        private String name;
        private String competenceTypeTitle;
        private String competenceNameTitle;
        private String needsAssessmentDomainTitle;
        private String needsAssessmentPriorityTitle;
        private String skillTitle;
        private String skillCourseTitle;

        public boolean equvalentOf(NeedsAssessmentDTO.Tree dto,String property){
            if(this.getParentId().equals(dto.getParentId()) && this.getName().equals(dto.getName()))
                return true;
            else
                return false;
        }

        public void setProperty(String property, String value){
            try {
                Field field = NeedsAssessmentDTO.Tree.class.getDeclaredField(property);
                field.set(this,value);
            } catch (Exception e) {
                System.out.println("failed");
            }
        }

        public String getProperty(String property){
            String result = null;
            try {
//                result = (String)PropertyUtils.getProperty(this,property);
                Field field = NeedsAssessmentDTO.Tree.class.getDeclaredField(property);
                result = field.get(this).toString();
            } catch (Exception e) {
                System.out.println("failed");
            }
            return result == null ? "" : result;
        }

        @Override
        public int hashCode(){
            return new HashCodeBuilder(17,31).
                    append(competenceNameTitle).
                    append(competenceTypeTitle).
                    append(needsAssessmentDomainTitle).
                    append(needsAssessmentPriorityTitle).
                    append(skillTitle).
                    toHashCode();
        }

        @Override
        public boolean equals(Object obj){
            if(!(obj instanceof NeedsAssessmentDTO))
                return false;
            return (this.getId().equals(((NeedsAssessmentDTO.Tree)obj).getId()));
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Create")
    public static class Create extends NeedsAssessmentDTO {
        private String objectName;
        private String objectCode;
//        private String Action;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Update")
    public static class Update {
        private Long needsAssessmentPriorityId;
//        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}

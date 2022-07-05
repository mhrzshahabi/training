package com.nicico.training.mapper.NeedAssessment;

import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.NeedsAssessment;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class NeedAssessmentBeanMapper {

    @Autowired
    protected ISkillService skillService;
    @Autowired
    protected ICourseService courseService;
    @Autowired
    protected ICategoryService categoryService;
    @Autowired
    protected ISubcategoryService subcategoryService;
    @Autowired
    protected IParameterValueService parameterValueService;

    @Mappings({
            @Mapping(source = "skillId", target = "courseCode", qualifiedByName = "toCourseCode"),
            @Mapping(source = "skillId", target = "courseTitle", qualifiedByName = "toCourseTitle"),
            @Mapping(source = "skillId", target = "categoryTitle", qualifiedByName = "toCategoryTitle"),
            @Mapping(source = "skillId", target = "subCategoryTitle", qualifiedByName = "toSubCategoryTitle"),
            @Mapping(source = "needsAssessmentPriorityId", target = "priority", qualifiedByName = "toPriority")
    })
    public abstract NeedsAssessmentDTO.CourseDetail toNeedsAssessmentCourseDetailDTO(NeedsAssessment needsAssessment);
    public abstract List<NeedsAssessmentDTO.CourseDetail> toNeedsAssessmentCourseDetailDTOList(List<NeedsAssessment> needsAssessmentList);


    @Named("toCourseCode")
    protected String toCourseCode(Long skillId) {
        if (skillId != null) {
            if (skillService.get(skillId).getCourseMainObjectiveId() != null)
                return courseService.get(skillService.get(skillId).getCourseMainObjectiveId()).getCode();
            else return null;
        }
        else return null;
    }

    @Named("toCourseTitle")
    protected String toCourseTitle(Long skillId) {
        if (skillId != null) {
            if (skillService.get(skillId).getCourseMainObjectiveId() != null)
                return courseService.get(skillService.get(skillId).getCourseMainObjectiveId()).getTitleFa();
            else return null;
        }
        else return null;
    }

    @Named("toCategoryTitle")
    protected String toCategoryTitle(Long skillId) {
        if (skillId != null)
            return categoryService.get(skillService.get(skillId).getCategoryId()).getTitleFa();
        else return null;
    }

    @Named("toSubCategoryTitle")
    protected String toSubCategoryTitle(Long skillId) {
        if (skillId != null)
            return subcategoryService.get(skillService.get(skillId).getSubCategoryId()).getTitleFa();
        else return null;
    }

    @Named("toPriority")
    protected String toPriority(Long needsAssessmentPriorityId) {
        if (needsAssessmentPriorityId != null)
            return parameterValueService.getInfo(needsAssessmentPriorityId).getTitle();
        else return null;
    }

}

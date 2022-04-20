package com.nicico.training.mapper.teachingHistory;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.EducationLevelDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.dto.TeachingHistoryDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.model.TeachingHistory;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import request.teachingHistory.ElsTeachingHistoryReqDto;
import response.academicBK.ElsEducationLevelDto;
import response.question.dto.ElsCategoryDto;
import response.question.dto.ElsSubCategoryDto;
import response.teachingHistory.ElsStudentsLevelDto;
import response.teachingHistory.ElsTeachingHistoryFindAllRespDto;
import response.teachingHistory.ElsTeachingHistoryRespDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TeachingHistoryBeanMapper {

    @Autowired
    protected ModelMapper modelMapper;
    @Autowired
    protected ITeacherService iTeacherService;
    @Autowired
    protected ICategoryService iCategoryService;
    @Autowired
    protected ISubcategoryService iSubcategoryService;
    @Autowired
    protected IParameterValueService parameterValueService;
    @Autowired
    protected IEducationLevelService iEducationLevelService;

    @Mapping(source = "categoryIds", target = "categories", qualifiedByName = "toCategoryInfos")
    @Mapping(source = "subCategoryIds", target = "subCategories", qualifiedByName = "toSubCategoryInfos")
    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    public abstract TeachingHistoryDTO.Create elsTeachHistoryReqToTeachHistoryCreate(ElsTeachingHistoryReqDto elsTeachingHistoryReqDto);

    @Mapping(source = "categoryIds", target = "categories", qualifiedByName = "toCategoryInfos")
    @Mapping(source = "subCategoryIds", target = "subCategories", qualifiedByName = "toSubCategoryInfos")
    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    public abstract TeachingHistoryDTO.Update elsTeachHistoryReqToTeachHistoryUpdate(ElsTeachingHistoryReqDto elsTeachingHistoryReqDto);

    @Mapping(source = "categories", target = "categoryIds", qualifiedByName = "toCategoryIds")
    @Mapping(source = "subCategories", target = "subCategoryIds", qualifiedByName = "toSubCategoryIds")
    @Mapping(source = "categories", target = "categories", qualifiedByName = "toElsCategories")
    @Mapping(source = "subCategories", target = "subCategories", qualifiedByName = "toElsSubCategories")
    @Mapping(source = "educationLevelId", target = "educationLevel", qualifiedByName = "toEducationLevel")
    @Mapping(source = "studentsLevelId", target = "studentsLevel", qualifiedByName = "toStudentsLevel")
    public abstract ElsTeachingHistoryRespDto teachHistoryInfoToElsHistoryResp(TeachingHistoryDTO.Info teachingHistoryDTO);

    @Mapping(source = "id", target = "categories", qualifiedByName = "toCategoryNames")
    @Mapping(source = "id", target = "subCategories", qualifiedByName = "toSubCategoryNames")
    @Mapping(source = "educationLevelId", target = "educationLevel", qualifiedByName = "toEducationLevel")
    @Mapping(source = "studentsLevelId", target = "studentsLevel", qualifiedByName = "toStudentsLevel")
    public abstract ElsTeachingHistoryFindAllRespDto teachHistoryToElsFindResp(TeachingHistory teachingHistory);

    public abstract List<ElsTeachingHistoryFindAllRespDto> teachHistoryListToElsFindRespList(List<TeachingHistory> employmentHistoryList);

    @Named("toCategoryInfos")
    List<CategoryDTO.Info> toCategoryInfos(List<Long> categoryIds) {
        List<CategoryDTO.Info> categoryInfoList = new ArrayList<>();
        for (Long categoryId : categoryIds) {
            categoryInfoList.add(iCategoryService.get(categoryId));
        }
        return categoryInfoList;
    }

    @Named("toSubCategoryInfos")
    List<SubcategoryDTO.Info> toSubCategoryInfos(List<Long> subCategoryIds) {
        List<SubcategoryDTO.Info> subCategoryInfoList = new ArrayList<>();
        for (Long subCategoryId : subCategoryIds) {
            subCategoryInfoList.add(iSubcategoryService.get(subCategoryId));
        }
        return subCategoryInfoList;
    }

    @Named("nationalCodeToTeacherId")
    Long nationalCodeToTeacherId(String nationalCode) {
        return iTeacherService.getTeacherIdByNationalCode(nationalCode);
    }

    @Named("toCategoryIds")
    List<Long> toCategoryIds(List<CategoryDTO.CategoryInfoTuple> categories) {
        return categories.stream().map(CategoryDTO.CategoryInfoTuple::getId).collect(Collectors.toList());
    }

    @Named("toSubCategoryIds")
    List<Long> toSubCategoryIds(List<SubcategoryDTO.SubCategoryInfoTuple> subCategories) {
        return subCategories.stream().map(SubcategoryDTO.SubCategoryInfoTuple::getId).collect(Collectors.toList());
    }

    @Named("toCategoryNames")
    List<String> toCategoryNames(Long teachHistoryId) {
        return iCategoryService.findCategoryNamesByTeachHistoryId(teachHistoryId);
    }

    @Named("toSubCategoryNames")
    List<String> toSubCategoryNames(Long teachHistoryId) {
        return iSubcategoryService.findSubCategoryNamesByTeachHistoryId(teachHistoryId);
    }

    @Named("toElsCategories")
    List<ElsCategoryDto> toElsCategories(List<CategoryDTO.CategoryInfoTuple> categories) {
        return modelMapper.map(categories, new TypeToken<List<ElsCategoryDto>>() {
        }.getType());
    }

    @Named("toElsSubCategories")
    List<ElsSubCategoryDto> toElsSubCategories(List<SubcategoryDTO.SubCategoryInfoTuple> subCategories) {
        return modelMapper.map(subCategories, new TypeToken<List<ElsSubCategoryDto>>() {
        }.getType());
    }

    @Named("toEducationLevel")
    ElsEducationLevelDto toEducationLevel(Long educationLevelId) {
        if (educationLevelId != null) {
            return iEducationLevelService.elsEducationLevel(educationLevelId);
        } else return null;
    }

    @Named("toStudentsLevel")
    ElsStudentsLevelDto toStudentsLevel(Long studentsLevelId) {
        if (studentsLevelId != null) {
            Optional<ParameterValue> parameterValue = parameterValueService.findById(studentsLevelId);
            ParameterValue studentsLevel = parameterValue.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            return modelMapper.map(studentsLevel, ElsStudentsLevelDto.class);
        } else
            return null;
    }

    @Mapping(source = "educationLevelId", target = "eduLevel", qualifiedByName = "toEducationLevelُTitle")
    @Mapping(source = "studentsLevelId", target = "stdLevel", qualifiedByName = "toStudentsLevelTitle")
    @Mapping(source = "duration", target = "durationInHour", qualifiedByName = "toDurationInHour")
    @Mapping(source = "startDate", target = "from")
    @Mapping(source = "endDate", target = "to")
    public abstract ElsTeachingHistoryFindAllRespDto.TeachingHistoryResume teachHistoryListToElsResumeResp(TeachingHistory teachingHistory);

    public abstract List<ElsTeachingHistoryFindAllRespDto.TeachingHistoryResume> teachHistoryListToElsResumeRespList(List<TeachingHistory> teachingHistoryList);

    @Named("toStudentsLevelTitle")
    String toStudentsLevelTitle(Long studentsLevelId) {
        if (studentsLevelId != null) {
            Optional<ParameterValue> parameterValue = parameterValueService.findById(studentsLevelId);
            ParameterValue studentsLevel = parameterValue.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            return studentsLevel.getTitle();
        } else
            return null;
    }

    @Named("toEducationLevelُTitle")
    String toEducationLevelُTitle(Long educationLevelId) {
        if (educationLevelId != null) {
            EducationLevelDTO.Info levelDTO = iEducationLevelService.get(educationLevelId);
            return levelDTO.getTitleFa();
        } else return null;
    }

    @Named("toDurationInHour")
    String toDurationInHour(Integer duration) {
        if (duration != null) {
            return duration.toString();
        } else return null;
    }

}

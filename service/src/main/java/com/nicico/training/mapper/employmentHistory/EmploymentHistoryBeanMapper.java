package com.nicico.training.mapper.employmentHistory;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.EmploymentHistory;
import com.nicico.training.model.ParameterValue;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import request.employmentHistory.ElsEmploymentHistoryReqDto;
import response.employmentHistory.ElsEmploymentHistoryFindAllRespDto;
import response.employmentHistory.ElsEmploymentHistoryRespDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class EmploymentHistoryBeanMapper {

    @Autowired
    protected IFileLabelService iFileLabelService;

    @Autowired
    protected ITeacherService iTeacherService;

    @Autowired
    protected ICategoryService iCategoryService;

    @Autowired
    protected ISubcategoryService iSubcategoryService;

    @Autowired
    protected IParameterValueService iParameterValueService;

    @Mapping(source = "categoryIds", target = "categories", qualifiedByName = "toCategoryInfos")
    @Mapping(source = "subCategoryIds", target = "subCategories", qualifiedByName = "toSubCategoryInfos")
    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    public abstract EmploymentHistoryDTO.Create elsEmpHistoryReqToEmpHistoryCreate(ElsEmploymentHistoryReqDto elsEmploymentHistoryReqDto);

    @Mapping(source = "categoryIds", target = "categories", qualifiedByName = "toCategoryInfos")
    @Mapping(source = "subCategoryIds", target = "subCategories", qualifiedByName = "toSubCategoryInfos")
    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    public abstract EmploymentHistoryDTO.Update elsEmpHistoryReqToEmpHistoryUpdate(ElsEmploymentHistoryReqDto elsEmploymentHistoryReqDto);

    @Mapping(source = "categories", target = "categoryIds", qualifiedByName = "toCategoryIds")
    @Mapping(source = "subCategories", target = "subCategoryIds", qualifiedByName = "toSubCategoryIds")
    public abstract ElsEmploymentHistoryRespDto empHistoryInfoToElsHistoryResp(EmploymentHistoryDTO.Info employmentHistoryDTO);

    @Mapping(source = "id", target = "categories", qualifiedByName = "toCategoryNames")
    @Mapping(source = "id", target = "subCategories", qualifiedByName = "toSubCategoryNames")
    @Mapping(source = "collaborationTypeId", target = "collaborationType", qualifiedByName = "toCollaborationTypeTitle")
    public abstract ElsEmploymentHistoryFindAllRespDto empHistoryToElsFindResp(EmploymentHistory employmentHistory);

    public abstract List<ElsEmploymentHistoryFindAllRespDto> empHistoryListToElsFindRespList(List<EmploymentHistory> employmentHistoryList);

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
    List<String> toCategoryNames(Long empHistoryId) {
        return iCategoryService.findCategoryNamesByEmpHistoryId(empHistoryId);
    }

    @Named("toSubCategoryNames")
    List<String> toSubCategoryNames(Long empHistoryId) {
        return iSubcategoryService.findSubCategoryNamesByEmpHistoryId(empHistoryId);
    }

    @Named("toCollaborationTypeTitle")
    String toCollaborationTypeTitle(Long collaborationTypeId) {
        if (collaborationTypeId != null) {
            Optional<ParameterValue> parameterValue = iParameterValueService.findById(collaborationTypeId);
            ParameterValue collaborationType = parameterValue.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            return collaborationType.getTitle();
        } else
            return null;
    }

}

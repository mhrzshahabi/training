package com.nicico.training.mapper.teachingHistory;

import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.dto.TeachingHistoryDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.TeachingHistory;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import request.teachingHistory.ElsTeachingHistoryReqDto;
import response.teachingHistory.ElsTeachingHistoryFindAllRespDto;
import response.teachingHistory.ElsTeachingHistoryRespDto;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TeachingHistoryBeanMapper {

    @Autowired
    protected ITeacherService iTeacherService;

    @Autowired
    protected ICategoryService iCategoryService;

    @Autowired
    protected ISubcategoryService iSubcategoryService;

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
    public abstract ElsTeachingHistoryRespDto teachHistoryInfoToElsHistoryResp(TeachingHistoryDTO.Info teachingHistoryDTO);

    @Mapping(source = "id", target = "categories", qualifiedByName = "toCategoryNames")
    @Mapping(source = "id", target = "subCategories", qualifiedByName = "toSubCategoryNames")
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

}

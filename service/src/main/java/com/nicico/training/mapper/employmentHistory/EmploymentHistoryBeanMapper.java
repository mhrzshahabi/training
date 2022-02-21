package com.nicico.training.mapper.employmentHistory;

import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.iservice.IFileLabelService;
import com.nicico.training.iservice.ITeacherService;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import request.employmentHistory.ElsEmploymentHistoryReqDto;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class EmploymentHistoryBeanMapper {

    @Autowired
    protected IFileLabelService iFileLabelService;

    @Autowired
    protected ITeacherService iTeacherService;

    @Mapping(source = "categoryIds", target = "categories", qualifiedByName = "toCategoryInfos")
    @Mapping(source = "subCategoryIds", target = "subCategories", qualifiedByName = "toSubCategoryInfos")
    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    @Mapping(source = "elsEmploymentHistoryReqDto", target = "collaborationDuration", qualifiedByName = "getSumOfMonthAndYear")
    public abstract EmploymentHistoryDTO.Create elsEmpHistoryReqToEmpHistoryCreate(ElsEmploymentHistoryReqDto elsEmploymentHistoryReqDto);

//    @Mapping(source = "fileLabels", target = "fileLabels", qualifiedByName = "getFileLabelsInfo")
//    public abstract HelpFilesDTO.Info toHelpFilesInfo(HelpFiles helpFiles);

//    public abstract List<HelpFilesDTO.Info> toHelpFilesInfoList(List<HelpFiles> HelpFileList);

    @Named("toCategoryInfos")
    List<CategoryDTO.Info> toCategoryInfos(List<Long> categoryIds) {
        return null;
    }

    @Named("toSubCategoryInfos")
    List<CategoryDTO.Info> toSubCategoryInfos(List<Long> subCategoryIds) {
        return null;
    }

    @Named("nationalCodeToTeacherId")
    Long nationalCodeToTeacherId(String nationalCode) {
        return iTeacherService.getTeacherIdByNationalCode(nationalCode);
    }

    @Named("getSumOfMonthAndYear")
    Integer getSumOfMonthAndYear(ElsEmploymentHistoryReqDto reqDto) {
        return reqDto.getCollaborationDurationMonth() + (reqDto.getCollaborationDurationYear() * 12);
    }

}

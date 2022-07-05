package com.nicico.training.mapper.requestItem;

import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.iservice.*;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class RequestItemCoursesDetailBeanMapper {

    @Autowired
    protected ICategoryService categoryService;
    @Autowired
    protected ISubcategoryService subcategoryService;

    @Mappings({
            @Mapping(source = "categoryTitle", target = "categoryId", qualifiedByName = "toCategoryId"),
            @Mapping(source = "requestItemCoursesDetailDTO", target = "subCategoryId", qualifiedByName = "toSubCategoryId"),
    })
    public abstract RequestItemCoursesDetailDTO.CourseCategoryInfo toCourseCategoryInfoDTO(RequestItemCoursesDetailDTO.Info requestItemCoursesDetailDTO);
    public abstract List<RequestItemCoursesDetailDTO.CourseCategoryInfo> toCourseCategoryInfoDTOList(List<RequestItemCoursesDetailDTO.Info> requestItemCoursesDetailDTOList);


    @Named("toCategoryId")
    protected Long toCategoryId(String categoryTitle) {
        return categoryService.findByTitleFa(categoryTitle).getId();
    }

    @Named("toSubCategoryId")
    protected Long toSubCategoryId(RequestItemCoursesDetailDTO.Info requestItemCoursesDetailDTO) {
        Long categoryId = categoryService.findByTitleFa(requestItemCoursesDetailDTO.getCategoryTitle()).getId();
        return subcategoryService.findByCategoryIdAndTitleFa(categoryId, requestItemCoursesDetailDTO.getSubCategoryTitle()).getId();
    }
}

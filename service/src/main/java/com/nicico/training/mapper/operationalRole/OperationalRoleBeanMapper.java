package com.nicico.training.mapper.operationalRole;

import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.model.Category;
import com.nicico.training.model.OperationalRole;
import com.nicico.training.model.Subcategory;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class OperationalRoleBeanMapper {
    @Autowired
    protected ICategoryService iCategoryService;
    @Autowired
    protected ISubcategoryService iSubcategoryService;
    @Autowired
    protected IOperationalRoleService iOperationalRoleService;

    @Mapping(source = "categories", target = "categories", qualifiedByName = "getCategoriesByIds")
    @Mapping(source = "subCategories", target = "subCategories", qualifiedByName = "getSubCategoriesByIds")
    public abstract OperationalRole toOperationalRole(OperationalRoleDTO.Create request);

    @Mapping(source = "id", target = "categories", qualifiedByName = "getCategoriesIds")
    @Mapping(source = "id", target = "subCategories", qualifiedByName = "getSubCategoriesIds")
    public abstract OperationalRoleDTO.Info toOperationalRoleInfoDto(OperationalRole operationalRole);

    public abstract List<OperationalRoleDTO.Info> toOperationalRoleInfoDtoList(List<OperationalRole> operationalRoleList);

    @Mapping(source = "categories", target = "categories", qualifiedByName = "getCategoriesByIds")
    @Mapping(source = "subCategories", target = "subCategories", qualifiedByName = "getSubCategoriesByIds")
    public abstract OperationalRole toOperationalRoleFromOperationalRoleUpdateDto(OperationalRoleDTO.Update request);

    @Mapping(source = "categories", target = "categories", ignore = true)
    @Mapping(source = "subCategories", target = "subCategories", ignore = true)
    public abstract OperationalRole copyOperationalRoleFrom(OperationalRole operationalRole);

    @Named("getCategoriesByIds")
    Set<Category> getCategoriesByIds(List<Long> categoryIds) {
        Set<Category> categories = new HashSet<>();
        if (categoryIds != null && categoryIds.size() > 0) {
            categories = iCategoryService.getCategoriesByIds(categoryIds);
        }
        return categories;
    }

    @Named("getSubCategoriesByIds")
    Set<Subcategory> getSubCategoriesByIds(List<Long> subCategoryIds) {
        Set<Subcategory> subcategories = new HashSet<>();
        if (subCategoryIds != null && subCategoryIds.size() > 0) {
            subcategories = iSubcategoryService.getSubcategoriesByIds(subCategoryIds);
        }
        return subcategories;
    }

    @Named("getCategoriesIds")
    Set<CategoryDTO.CategoryInfoTuple> getCategoriesIds(Long operationRoleId) {
        OperationalRole operationalRole = iOperationalRoleService.getOperationalRole(operationRoleId);
        Set<Category> categories = iOperationalRoleService.getCategories(operationalRole.getId());
        List<CategoryDTO.CategoryInfoTuple> categoryInfoTuples = new ArrayList<>();
        if (categories!=null){
            for (Category category : categories) {
                CategoryDTO.CategoryInfoTuple tuple = new CategoryDTO.CategoryInfoTuple();
                tuple.setId(category.getId());
                tuple.setCode(category.getCode());
                tuple.setTitleFa(category.getTitleFa());
                tuple.setTitleEn(category.getTitleEn());
                tuple.setDescription(category.getDescription());
                categoryInfoTuples.add(tuple);
            }
            return new HashSet<>(categoryInfoTuples);
        }else
            return null;

    }

    @Named("getSubCategoriesIds")
    Set<SubcategoryDTO.SubCategoryInfoTuple> getSubCategoriesIds(Long operationRoleId) {
        OperationalRole operationalRole = iOperationalRoleService.getOperationalRole(operationRoleId);
        Set<Subcategory> subCategories = iOperationalRoleService.getSubCategories(operationalRole.getId());;
        List<SubcategoryDTO.SubCategoryInfoTuple> subCategoryInfoTuples = new ArrayList<>();
        if (subCategories!=null){
            for (Subcategory subcategory : subCategories) {
                SubcategoryDTO.SubCategoryInfoTuple tuple = new SubcategoryDTO.SubCategoryInfoTuple();
                tuple.setId(subcategory.getId());
                tuple.setTitleFa(subcategory.getTitleFa());
                tuple.setTitleEn(subcategory.getTitleEn());
                subCategoryInfoTuples.add(tuple);
            }
            return new HashSet<>(subCategoryInfoTuples);
        }else
            return null;


    }
}

package com.nicico.training.mapper.teacherPublication;

import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.dto.teacherPublications.ElsPublicationDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.model.Publication;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static com.nicico.training.utility.persianDate.PersianDate.getEpochDate;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TeacherPublicationBeanMapper {

    @Autowired
    protected ICategoryService iCategoryService;
    @Autowired
    protected ISubcategoryService iSubcategoryService;

    @Mapping(target = "publicationDate", source = "publicationDate", qualifiedByName = "getPublicationDate")
    public abstract ElsPublicationDTO.Info toElsPublicationDTOInfo(Publication publication);

    @Mapping(target = "publicationDate", source = "publicationDate", qualifiedByName = "getPublicationDate")
    public abstract ElsPublicationDTO.UpdatedInfo toTeacherUpdatedPublicationInfoDto(Publication result);


    public abstract List<ElsPublicationDTO.Info> toElsPublicationDTOInfoList(List<Publication> publications);

    @Named("getPublicationDate")
    Long getPublicationDate(String publicationDate) {
        if (publicationDate != null) {
            Date date = getEpochDate(publicationDate, "04:30");
            return (date.getTime() * 1000);
        } else {
            return null;
        }
    }

    @Mapping(target = "publicationDate", source = "publicationDate", qualifiedByName = "getPublicationDateString")
    public abstract Publication toPublication(ElsPublicationDTO.Create2 elsPublicationDTO);

    @Mapping(target = "publicationDate", source = "publicationDate", qualifiedByName = "getPublicationDateString")
    public abstract Publication toTeacherUpdatedPublication(ElsPublicationDTO.Update2 elsPublicationUpdateDto2);



    @Named("getPublicationDateString")
    String getPublicationDateString(Long publicationDate) {
        if (publicationDate != null && publicationDate != 0) {
            long time = publicationDate;
            Date date = new Date(time);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.add(Calendar.HOUR_OF_DAY, 4);
            calendar.add(Calendar.MINUTE, 30);
            date = calendar.getTime();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String pDate = DateUtil.convertMiToKh(dateFormat.format(date));
            return pDate;
        } else {
            return null;
        }
    }
    @Mapping(source = "categoryIds", target = "categories", qualifiedByName = "toCategoryInfos")
    @Mapping(source = "subCategoryIds", target = "subCategories", qualifiedByName = "toSubCategoryInfos")
    public abstract ElsPublicationDTO.Create2 toPublicationCreate2(ElsPublicationDTO.Create elsPublicationDTO);

    @Mapping(source = "categoryIds", target = "categories", qualifiedByName = "toCategoryInfos")
    @Mapping(source = "subCategoryIds", target = "subCategories", qualifiedByName = "toSubCategoryInfos")
    public abstract ElsPublicationDTO.Update2 toPublicationUpdateDto2(ElsPublicationDTO.Update elsPublicationDTO);


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

    public abstract ElsPublicationDTO.Resume toElsPublicationResumeDTO(Publication publications);

    public abstract List<ElsPublicationDTO.Resume> toElsPublicationResumeDTOList(List<Publication> publications);
}

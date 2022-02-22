package com.nicico.training.mapper.academicBK;

import com.nicico.training.dto.AcademicBKDTO;
import com.nicico.training.iservice.IFileLabelService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.AcademicBK;
import com.nicico.training.utility.persianDate.PersianDate;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import request.academicBK.ElsAcademicBKReqDto;
import response.academicBK.ElsAcademicBKRespDto;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class AcademicBKBeanMapper {

    @Autowired
    protected IFileLabelService iFileLabelService;

    @Autowired
    protected ITeacherService teacherService;

    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    @Mapping(source = "date", target = "date", qualifiedByName = "longDateToStringDate")
    public abstract AcademicBKDTO.Create elsAcademicBKReqToAcademicBKCreate (ElsAcademicBKReqDto elsAcademicBKReqDto);

    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    @Mapping(source = "date", target = "date", qualifiedByName = "longDateToStringDate")
    public abstract AcademicBKDTO.Update elsAcademicBKReqToAcademicBKUpdate (ElsAcademicBKReqDto elsAcademicBKReqDto);

    @Mapping(source = "date", target = "date", qualifiedByName = "StringDateToLongDate")
    public abstract ElsAcademicBKRespDto academicBKInfoToElsAcademicBKRes (AcademicBKDTO.Info info);

    @Mapping(source = "date", target = "date", qualifiedByName = "StringDateToLongDate")
    public abstract ElsAcademicBKRespDto academicBKToElsAcademicBKRes (AcademicBK academicBK);

    public abstract List<ElsAcademicBKRespDto> academicBKToElsAcademicBKResList(List<AcademicBK> academicBKList);

    @Named("nationalCodeToTeacherId")
    Long nationalCodeToTeacherId(String nationalCode) {
        return teacherService.getTeacherIdByNationalCode(nationalCode);
    }

    @Named("longDateToStringDate")
    String longDateToStringDate(Long lDate) {
        Date _date = new Date(lDate);
        return PersianDate.convertToTrainingPersianDate(_date);
    }

    @Named("StringDateToLongDate")
    Long StringDateToLongDate(String sDate) throws ParseException {
        return 1L;
    }

}

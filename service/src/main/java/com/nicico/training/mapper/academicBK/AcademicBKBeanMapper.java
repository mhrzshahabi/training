package com.nicico.training.mapper.academicBK;

import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AcademicBKDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.AcademicBK;
import com.nicico.training.model.ParameterValue;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import request.academicBK.ElsAcademicBKReqDto;
import response.academicBK.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import static com.nicico.training.utility.persianDate.PersianDate.getEpochDate;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class AcademicBKBeanMapper {

    @Autowired
    protected ModelMapper modelMapper;
    @Autowired
    protected ITeacherService teacherService;
    @Autowired
    protected IParameterValueService parameterValueService;
    @Autowired
    protected IEducationLevelService educationLevelService;
    @Autowired
    protected IEducationMajorService educationMajorService;
    @Autowired
    protected IEducationOrientationService educationOrientationService;


    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    @Mapping(source = "date", target = "date", qualifiedByName = "longDateToStringDate")
    public abstract AcademicBKDTO.Create elsAcademicBKReqToAcademicBKCreate (ElsAcademicBKReqDto elsAcademicBKReqDto);

    @Mapping(source = "teacherNationalCode", target = "teacherId", qualifiedByName = "nationalCodeToTeacherId")
    @Mapping(source = "date", target = "date", qualifiedByName = "longDateToStringDate")
    public abstract AcademicBKDTO.Update elsAcademicBKReqToAcademicBKUpdate (ElsAcademicBKReqDto elsAcademicBKReqDto);

    @Mapping(source = "date", target = "date", qualifiedByName = "StringDateToLongDate")
    @Mapping(source = "educationLevelId", target = "educationLevel", qualifiedByName = "toEducationLevel")
    @Mapping(source = "educationMajorId", target = "educationMajor", qualifiedByName = "toEducationMajor")
    @Mapping(source = "educationOrientationId", target = "educationOrientation", qualifiedByName = "toEducationOrientation")
    @Mapping(source = "universityId", target = "university", qualifiedByName = "toUniversity")
    public abstract ElsAcademicBKRespDto academicBKInfoToElsAcademicBKRes (AcademicBKDTO.Info info);

    @Mapping(source = "educationLevelId", target = "educationLevel", qualifiedByName = "toEducationLevel")
    @Mapping(source = "educationMajorId", target = "educationMajor", qualifiedByName = "toEducationMajor")
    @Mapping(source = "educationOrientationId", target = "educationOrientation", qualifiedByName = "toEducationOrientation")
    @Mapping(source = "universityId", target = "university", qualifiedByName = "toUniversity")
    @Mapping(source = "duration", target = "duration")
    @Mapping(source = "academicGrade", target = "academicGrade")
    public abstract ElsAcademicBKFindAllRespDto academicBKToElsAcademicBKRes (AcademicBK academicBK);

    public abstract List<ElsAcademicBKFindAllRespDto> academicBKToElsAcademicBKFindAllRes(List<AcademicBK> academicBKList);

    @Named("nationalCodeToTeacherId")
    Long nationalCodeToTeacherId(String nationalCode) {
        return teacherService.getTeacherIdByNationalCode(nationalCode);
    }

    @Named("longDateToStringDate")
    String longDateToStringDate(Long lDate) {
        if (lDate != null) {
            Date date = new Date(lDate);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.add(Calendar.HOUR_OF_DAY, 4);
            calendar.add(Calendar.MINUTE, 30);
            date = calendar.getTime();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return DateUtil.convertMiToKh(dateFormat.format(date));
        } else return null;
    }

    @Named("StringDateToLongDate")
    Long StringDateToLongDate(String sDate) {
        if (sDate != null) {
            Date date = getEpochDate(sDate, "04:30");
            return (date.getTime() * 1000);
        } else
            return null;
    }

    @Named("toEducationLevel")
    ElsEducationLevelDto toEducationLevel(Long educationLevelId) {
        if (educationLevelId != null) {
            return educationLevelService.elsEducationLevel(educationLevelId);
        } else return null;
    }

    @Named("toEducationMajor")
    ElsEducationMajorDto toEducationMajor(Long educationMajorId) {
        if (educationMajorId != null) {
            return educationMajorService.elsEducationMajor(educationMajorId);
        } else return null;
    }

    @Named("toEducationOrientation")
    ElsEducationOrientationDto toEducationOrientation(Long educationOrientationId) {
        if (educationOrientationId != null) {
            return educationOrientationService.elsEducationOrientation(educationOrientationId);
        } else return null;
    }

    @Named("toUniversity")
    ElsUniversityDto toUniversity(Long universityId) {
        if (universityId != null) {
            Optional<ParameterValue> parameterValue = parameterValueService.findById(universityId);
            ParameterValue university = parameterValue.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            return modelMapper.map(university, ElsUniversityDto.class);
        } else
            return null;
    }

}

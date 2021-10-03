package com.nicico.training.mapper.calendar;

import com.nicico.training.dto.CalendarDTO;
import com.nicico.training.model.Calendar;
import com.nicico.training.model.Course;
import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
import org.mapstruct.*;
import request.course.CourseUpdateRequest;
import response.course.dto.CourseDto;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface CalendarBeanMapper {

    CalendarDTO toCalendar(Calendar calendar);
    List<CalendarDTO> toCalendars(List<Calendar> calendars);

}

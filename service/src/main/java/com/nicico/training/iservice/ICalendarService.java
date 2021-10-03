package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AcademicBKDTO;
import com.nicico.training.model.AcademicBK;
import com.nicico.training.model.Calendar;

import java.util.List;

public interface ICalendarService {

    List<Calendar> getAllData();

}

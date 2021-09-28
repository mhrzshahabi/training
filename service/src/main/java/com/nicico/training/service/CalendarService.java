package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:14 AM
    */


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ICalendarService;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.model.Calendar;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.repository.CalendarDAO;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.SubcategoryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.question.dto.ElsCategoryDto;

import java.util.*;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class CalendarService implements ICalendarService {

    private final CalendarDAO calendarDAO;

    @Override
    public List<Calendar> getAllData() {
        return calendarDAO.findAll();
    }
}

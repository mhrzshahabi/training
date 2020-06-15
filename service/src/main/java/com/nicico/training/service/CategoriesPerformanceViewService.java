package com.nicico.training.service;

import com.nicico.training.dto.CategoriesPerformanceViewDTO;
import com.nicico.training.model.CategoriesPerformanceView;
import com.nicico.training.repository.CategoriesPerformanceViewDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class CategoriesPerformanceViewService extends BaseService<CategoriesPerformanceView, Long, CategoriesPerformanceViewDTO.Info, CategoriesPerformanceViewDTO.Info, CategoriesPerformanceViewDTO.Info, CategoriesPerformanceViewDTO.Info, CategoriesPerformanceViewDAO>{
    @Autowired
    CategoriesPerformanceViewService(CategoriesPerformanceViewDAO categoriesPerformanceViewDAO) {super(new CategoriesPerformanceView(), categoriesPerformanceViewDAO);}
}

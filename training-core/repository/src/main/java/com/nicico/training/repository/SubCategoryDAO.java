package com.nicico.training.repository;/*
com.nicico.training.repository
@author : banifatemi
@Date : 6/3/2019
@Time :11:44 AM
    */

import com.nicico.training.model.SubCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SubCategoryDAO extends JpaRepository<SubCategory,Long> , JpaSpecificationExecutor<SubCategory> {
}

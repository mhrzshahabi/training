package com.nicico.training.repository;/*
com.nicico.training.repository
@author : banifatemi
@Date : 6/3/2019
@Time :11:44 AM
    */

import com.nicico.training.model.Subcategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubcategoryDAO extends JpaRepository<Subcategory, Long>, JpaSpecificationExecutor<Subcategory> {

    List<Subcategory> findAllByCategoryId(Long categoryId);
}

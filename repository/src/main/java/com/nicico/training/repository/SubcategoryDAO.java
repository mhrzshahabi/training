package com.nicico.training.repository;/*
com.nicico.training.repository
@author : banifatemi
@Date : 6/3/2019
@Time :11:44 AM
    */

import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubcategoryDAO extends JpaRepository<Subcategory, Long>, JpaSpecificationExecutor<Subcategory> {

    List<Subcategory> findAllByCategoryId(Long categoryId);
    @Query(value = "SELECT f_subcategory FROM tbl_teacher_subcategory WHERE f_teacher = :teacherId",nativeQuery = true)
    List<Long> findAllWithTeacher(Long teacherId);
}

package com.nicico.training.repository;

import com.nicico.training.model.QuestionBank;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionBankDAO extends JpaRepository<QuestionBank, Long>, JpaSpecificationExecutor<QuestionBank> {

    @Query(value = "select max(n_code_id) from tbl_question_bank", nativeQuery = true)
    Integer getLastCodeId();

    @Query(value = "select * from tbl_question_bank where ID in(:ids)", nativeQuery = true)
    List<QuestionBank> findByIds(List<Long> ids);

    @EntityGraph(attributePaths = {"questionType", "displayType", "category", "course", "tclass", "tclass.teacher", "tclass.teacher.personality", "tclass.course", "subCategory", "teacher"})
    @Override
    List<QuestionBank> findAll(@Nullable Specification<QuestionBank> var1);

    List<QuestionBank> findByTclassId(Long id);

    Page<QuestionBank> findAllByTeacherId(Long teacherId, Pageable pageable);

    Page<QuestionBank> findAll(Pageable pageable);

   @Query(value = "SELECT * FROM tbl_question_bank WHERE (f_category_id IS NULL AND f_subcategory_id IS NULL ) OR (f_category_id IN (:categories) OR f_subcategory_id IN (:subCategories))",nativeQuery = true)
   Page<QuestionBank> findAllWithCategoryAndSubCategory(List<Long> categories,List<Long> subCategories,Pageable pageable);

    @Query(value = "SELECT * FROM tbl_question_bank WHERE (f_category_id IS NULL AND f_subcategory_id IS NULL ) OR (f_category_id IN (:categories) OR f_subcategory_id IN (:subCategories))",nativeQuery = true)
   List<QuestionBank>  findAllWithCategoryAndSubList(List<Long> categories,List<Long> subCategories);
}

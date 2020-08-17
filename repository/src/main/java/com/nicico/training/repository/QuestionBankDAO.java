/*
ghazanfari_f, 8/29/2019, 10:43 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.JobGroup;
import com.nicico.training.model.QuestionBank;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionBankDAO extends JpaRepository<QuestionBank, Long>, JpaSpecificationExecutor<QuestionBank> {

  /*  @Query(value = "select max(n_code_id) from tbl_question_bank where f_category_id=:categoryID and f_subcategory_id is null",nativeQuery = true)
    Integer getMaxCodeIDWithCategory(Long categoryID);

    @Query(value = "select max(n_code_id) from tbl_question_bank where f_subcategory_id =:subCategoryID",nativeQuery = true)
    Integer getMaxCodeIDWithSubCategory(Long subCategoryID);

    @Query(value = "select max(n_code_id) from tbl_question_bank where f_category_id is null and f_subcategory_id is null",nativeQuery = true)
    Integer getMaxCodeIDWithoutCategoryAndSubCategory();*/

    @Query(value = "select max(n_code_id) from tbl_question_bank",nativeQuery = true)
    Integer getLastCodeId();

    @Query(value = "select * from tbl_question_bank where ID in(:ids)",nativeQuery = true)
    List<QuestionBank> findByIds(List<Long> ids);
}

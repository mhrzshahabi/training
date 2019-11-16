package com.nicico.training.repository;

import com.nicico.training.model.ClassCheckList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClassCheckListDAO extends JpaRepository<ClassCheckList, Long>, JpaSpecificationExecutor<ClassCheckList> {

List<ClassCheckList> getAllByTclassId(Long id);

@Query(value = "select  f_check_list_item_id from tbl_Class_Check_List where f_check_list_item_id =:checklistItemId",nativeQuery = true)
List<Long> getCheckListItemIdsBychecklistItemId(@Param("checklistItemId") Long id);

//@Query("select c.checkListItemId from ClassCheckList c where c.tclassId=:tclassid")
@Query(value = "select f_check_list_item_id from tbl_Class_Check_List where f_tclass_id=:tclassid ",nativeQuery = true)
List<Long> getCheckListItemIdsByTclassId(@Param("tclassid") Long id);

}

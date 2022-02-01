package com.nicico.training.repository;

import com.nicico.training.model.ClassCheckList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public interface ClassCheckListDAO extends JpaRepository<ClassCheckList, Long>, JpaSpecificationExecutor<ClassCheckList> {

    @Query(value = "select  f_check_list_item_id from tbl_Class_Check_List where f_check_list_item_id =:checklistItemId", nativeQuery = true)
    List<Long> getCheckListItemIdsBychecklistItemId(@Param("checklistItemId") Long id);

    @Query(value = "select f_check_list_item_id from tbl_Class_Check_List where f_tclass_id=:tclassid ", nativeQuery = true)
    List<Long> getCheckListItemIdsByTclassId(@Param("tclassid") Long id);

    @Query(value = "select f_check_list_item_id from tbl_Class_Check_List where f_tclass_id=:tclassid ", nativeQuery = true)
    Set<Long> getSetCheckListItemIdsByTclassId(@Param("tclassid") Long id);

    List<ClassCheckList> findClassCheckListByTclassId(Long id);

    @Modifying
    @Query(value = "delete from tbl_Class_Check_List where f_Tclass_id =:tclassid and f_check_list_item_id in (select id from tbl_check_list_item where f_check_list_id =:checklistId)", nativeQuery = true)
    void deleteByClassIdAndCheckListId(@Param("tclassid") Long tclassid, @Param("checklistId") Long checklistId);

    ClassCheckList findClassCheckListByTclassIdAndCheckListItemId(long classId,Long checkListItemId);
}

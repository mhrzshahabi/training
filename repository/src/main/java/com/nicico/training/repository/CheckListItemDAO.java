package com.nicico.training.repository;

import com.nicico.training.model.CheckListItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CheckListItemDAO  extends JpaRepository<CheckListItem,Long>, JpaSpecificationExecutor<CheckListItem> {

@Query(value = "select * from tbl_check_list_item where checkListId=:checklistid ",nativeQuery = true)
List<CheckListItem> getCheckListItem(@Param("checklistid") Long id);

//List<CheckListItem> getCheckListItemsByCheckListOrCheckListId();
List<CheckListItem> getCheckListItemsByCheckListId(Long id);



}

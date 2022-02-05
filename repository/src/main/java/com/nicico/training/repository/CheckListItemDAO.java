package com.nicico.training.repository;

import com.nicico.training.model.CheckListItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CheckListItemDAO extends JpaRepository<CheckListItem, Long>, JpaSpecificationExecutor<CheckListItem> {

    List<CheckListItem> getCheckListItemsByCheckListId(Long id);

    @Query(value = "select  f_check_list_id from tbl_check_list_item where ID=:checkListItemId ", nativeQuery = true)
    Long getCheckListId(@Param("checkListItemId") Long id);
}

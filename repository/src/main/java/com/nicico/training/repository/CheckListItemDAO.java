package com.nicico.training.repository;

import com.nicico.training.model.CheckListItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface CheckListItemDAO  extends JpaRepository<CheckListItem,Long>, JpaSpecificationExecutor<CheckListItem> {


}

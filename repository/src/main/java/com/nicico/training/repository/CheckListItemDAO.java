package com.nicico.training.repository;
import com.nicico.training.model.CheckListItem;
import org.apache.catalina.LifecycleState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface CheckListItemDAO  extends JpaRepository<CheckListItem,Long>, JpaSpecificationExecutor<CheckListItem> {


}

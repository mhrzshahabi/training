package com.nicico.training.repository;

import com.nicico.training.model.ViewClass;
import org.springframework.data.jpa.repository.*;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.Query;

import java.util.List;

@Repository
public interface ViewClassDAO extends BaseDAO<ViewClass, Long>, JpaSpecificationExecutor<ViewClass> {

    @Query(value = "select id from VIEW_MOBILE_CLASS_ALARM", nativeQuery = true)
    List<Long> allClassHasMobileAlarm();

}
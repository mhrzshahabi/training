package com.nicico.training.repository;

import com.nicico.training.model.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;

@Repository
public interface TeacherDAO extends JpaRepository<Teacher, Long>, JpaSpecificationExecutor<Teacher> {

    @Modifying
    @Query(value = "update TBL_TEACHER set" +
            " C_ATTACH_PHOTO = :attachFileName " +
            " WHERE ID= :id" ,nativeQuery = true)
    @Transactional
    public void addAttach(@Param("id") Long id, @Param("attachFileName") String attachFileName);

}

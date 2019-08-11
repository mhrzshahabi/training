package com.nicico.training.repository;

import com.nicico.training.model.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface TeacherDAO extends JpaRepository<Teacher, Long>, JpaSpecificationExecutor<Teacher> {

    @Modifying
    @Query(value = "update TBL_TEACHER set" +
            " C_ATTACH_PHOTO = :attachFileName " +
            " WHERE ID= :id" ,nativeQuery = true)
    @Transactional
    public void addAttach(@Param("id") Long id, @Param("attachFileName") String attachFileName);

    @Modifying
    @Query(value = "select * from TBL_TEACHER where C_NATIONAL_CODE = :nationalCode",nativeQuery = true)
    @Transactional
    public List<Teacher> findByNationalCode(@Param("nationalCode") String nationalCode);

    @Modifying
    @Query(value = "select * from TBL_TEACHER where C_NATIONAL_CODE = :nationalCode and ID != :id",nativeQuery = true)
    @Transactional
    public List<Teacher> findByNationalCode(@Param("id") Long id, @Param("nationalCode") String nationalCode);

}

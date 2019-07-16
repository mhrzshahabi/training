package com.nicico.training.repository;

import com.nicico.training.model.Skill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SkillDAO extends JpaRepository<Skill, Long>, JpaSpecificationExecutor<Skill> {
    @Query(value = "select nvl(max(s.c_code),'0') maxCode from training.tbl_skill s  where s.c_code like '?"+ "%'", nativeQuery = true)
    String findMaxSkillCode(String skillCodeStart);

}

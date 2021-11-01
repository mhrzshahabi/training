package com.nicico.training.repository;

import com.nicico.training.model.PersonalInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public interface PersonalInfoDAO extends JpaRepository<PersonalInfo, Long>, JpaSpecificationExecutor<PersonalInfo> {

    @Transactional
    Optional<PersonalInfo> findByNationalCode(@Param("nationalCode") String nationalCode);


    @Query(value = "select personnel.NATIONAL_CODE AS " + "\"code\"" +
            ",contact.C_MOBILE AS"+ "\"mobile\""+
            " from TBL_PERSONNEL personnel \n" +
            "left join TBL_CONTACT_INFO contact on contact.ID = personnel.F_CONTACT_INFO "+
            "WHERE contact.C_MOBILE like :mobile AND personnel.NATIONAL_CODE = :nationalCode",nativeQuery = true)
    List<Map<String,Object>> findAllByNationalCodeAndMobileNumber(@Param("mobile") String mobileNumber, @Param("nationalCode") String nationalCode);
}

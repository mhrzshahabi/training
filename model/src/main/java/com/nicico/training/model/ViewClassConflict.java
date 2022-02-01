package com.nicico.training.model;

import com.nicico.training.model.compositeKey.ClassConflictKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_class_conflict")
public class ViewClassConflict {

    @EmbeddedId
    ClassConflictKey id;

    @Column(name = "term_Id")
    private Long termId;

    @Column(name = "session_date")
    private String sessionDate;

    @Column(name = "class1_Id")
    private Long class1Id;

    @Column(name = "class2_Id")
    private Long class2Id;

    @Column(name = "c1_code")
    private String c1Code;

    @Column(name = "c2_code")
    private String c2Code;

    @Column(name = "s1_start_hour")
    private String session1StartHour;

    @Column(name = "s1_end_hour")
    private String session1EndHour;

    @Column(name = "s2_start_hour")
    private String session2StartHour;

    @Column(name = "s2_end_hour")
    private String session2EndHour;

    @Column(name = "student_first_name")
    private String studentFirstName;

    @Column(name = "student_last_name")
    private String studentLastName;

    @Column(name = "student_national_code")
    private String studentNationalCode;
}

package com.nicico.training.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tbl_need_assessment_group_result")
public class NeedAssessmentGroupResult {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "need_assessment_group_result_seq")
    @SequenceGenerator(name = "need_assessment_group_result_seq", sequenceName = "seq_need_assessment_group_result_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "EXCEL_REFERENCE")
    private String excelReference;

    @Column(name = "BLOB_FILE")
    private byte[] blobFile;

    @Column(name = "CREATED_BY")
    private String createdBy;

    @Column(name = "CREATE_DATE")
    private Timestamp createDate;

    @PrePersist
    public void setCreateTime(){
        this.createDate = new Timestamp(System.currentTimeMillis());
    }
}

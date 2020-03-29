package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import javax.persistence.*;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"},callSuper = false)
@Entity
@Table(name = "tbl_province")
public class Province extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE,generator = "province_seq")
    @SequenceGenerator(name = "province_seq",sequenceName = "seq_province_id",allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_name_fa", nullable = false,unique = true)
    private String nameFa;

    @Column(name = "c_name_en")
    private String nameEn;

    @OneToMany(mappedBy = "province",fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    private List<Polis> polisList;
}
